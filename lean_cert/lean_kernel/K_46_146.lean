import Sound
import lean_certs.cert_46_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_146_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 46) (d := 146) (c := cert_46_146) (by decide)
