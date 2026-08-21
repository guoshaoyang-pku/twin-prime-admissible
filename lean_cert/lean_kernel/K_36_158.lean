import Sound
import lean_certs.cert_36_158

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H36_gt_158_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 36) (d := 158) (c := cert_36_158) (by decide)
