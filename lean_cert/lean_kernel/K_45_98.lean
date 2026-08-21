import Sound
import lean_certs.cert_45_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_98_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 45) (d := 98) (c := cert_45_98) (by decide)
