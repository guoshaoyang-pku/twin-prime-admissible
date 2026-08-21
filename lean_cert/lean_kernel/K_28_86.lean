import Sound
import lean_certs.cert_28_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_86_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 28) (d := 86) (c := cert_28_86) (by decide)
