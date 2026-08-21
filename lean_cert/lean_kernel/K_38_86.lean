import Sound
import lean_certs.cert_38_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_86_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 38) (d := 86) (c := cert_38_86) (by decide)
