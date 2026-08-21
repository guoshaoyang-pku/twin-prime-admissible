import Sound
import lean_certs.cert_49_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_116_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 49) (d := 116) (c := cert_49_116) (by decide)
