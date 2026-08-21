import Sound
import lean_certs.cert_48_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_158_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 48) (d := 158) (c := cert_48_158) (by decide)
