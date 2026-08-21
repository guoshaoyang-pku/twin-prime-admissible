import Sound
import lean_certs.cert_28_122

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H28_gt_122_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 28) (d := 122) (c := cert_28_122) (by decide)
