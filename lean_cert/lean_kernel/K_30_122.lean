import Sound
import lean_certs.cert_30_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_122_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 30) (d := 122) (c := cert_30_122) (by decide)
