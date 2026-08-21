import Sound
import lean_certs.cert_29_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_86_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 29) (d := 86) (c := cert_29_86) (by decide)
