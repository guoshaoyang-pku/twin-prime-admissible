import Sound
import lean_certs.cert_37_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_146_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 37) (d := 146) (c := cert_37_146) (by decide)
