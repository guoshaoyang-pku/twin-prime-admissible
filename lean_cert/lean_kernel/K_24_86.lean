import Sound
import lean_certs.cert_24_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_86_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 24) (d := 86) (c := cert_24_86) (by decide)
