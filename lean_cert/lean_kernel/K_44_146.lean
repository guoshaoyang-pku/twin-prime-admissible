import Sound
import lean_certs.cert_44_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_146_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 44) (d := 146) (c := cert_44_146) (by decide)
