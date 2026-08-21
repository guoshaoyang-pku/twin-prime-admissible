import Sound
import lean_certs.cert_25_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_86_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 25) (d := 86) (c := cert_25_86) (by decide)
