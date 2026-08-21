import Sound
import lean_certs.cert_40_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_98_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 40) (d := 98) (c := cert_40_98) (by decide)
