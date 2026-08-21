import Sound
import lean_certs.cert_33_146

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H33_gt_146_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 33) (d := 146) (c := cert_33_146) (by decide)
