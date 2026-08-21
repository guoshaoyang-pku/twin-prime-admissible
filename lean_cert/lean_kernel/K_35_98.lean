import Sound
import lean_certs.cert_35_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_98_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 35) (d := 98) (c := cert_35_98) (by decide)
