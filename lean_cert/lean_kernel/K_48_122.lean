import Sound
import lean_certs.cert_48_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_122_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 48) (d := 122) (c := cert_48_122) (by decide)
