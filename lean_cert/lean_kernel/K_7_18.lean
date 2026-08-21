import Sound
import lean_certs.cert_7_18

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H7_gt_18_kernel : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 7) (d := 18) (c := cert_7_18) (by decide)
