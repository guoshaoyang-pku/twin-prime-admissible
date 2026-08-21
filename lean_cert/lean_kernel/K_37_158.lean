import Sound
import lean_certs.cert_37_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_158_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 37) (d := 158) (c := cert_37_158) (by decide)
