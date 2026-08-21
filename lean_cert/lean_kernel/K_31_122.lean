import Sound
import lean_certs.cert_31_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_122_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 31) (d := 122) (c := cert_31_122) (by decide)
