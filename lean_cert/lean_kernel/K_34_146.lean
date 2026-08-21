import Sound
import lean_certs.cert_34_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_146_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 34) (d := 146) (c := cert_34_146) (by decide)
