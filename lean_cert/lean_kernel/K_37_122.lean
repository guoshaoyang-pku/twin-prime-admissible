import Sound
import lean_certs.cert_37_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_122_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 37) (d := 122) (c := cert_37_122) (by decide)
