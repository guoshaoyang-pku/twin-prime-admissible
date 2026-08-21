import Sound
import lean_certs.cert_36_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_146_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 36) (d := 146) (c := cert_36_146) (by decide)
