import Sound
import lean_certs.cert_22_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_66_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 22) (d := 66) (c := cert_22_66) (by decide)
