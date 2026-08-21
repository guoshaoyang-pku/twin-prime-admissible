import Sound
import lean_certs.cert_30_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_116_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 30) (d := 116) (c := cert_30_116) (by decide)
