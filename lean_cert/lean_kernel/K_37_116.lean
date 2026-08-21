import Sound
import lean_certs.cert_37_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_116_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 37) (d := 116) (c := cert_37_116) (by decide)
