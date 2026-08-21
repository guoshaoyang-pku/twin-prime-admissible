import Sound
import lean_certs.cert_49_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_158_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 49) (d := 158) (c := cert_49_158) (by decide)
