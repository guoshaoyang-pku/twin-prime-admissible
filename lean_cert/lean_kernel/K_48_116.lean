import Sound
import lean_certs.cert_48_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_116_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 48) (d := 116) (c := cert_48_116) (by decide)
