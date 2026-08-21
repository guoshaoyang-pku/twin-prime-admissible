import Sound
import lean_certs.cert_33_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_86_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 33) (d := 86) (c := cert_33_86) (by decide)
