import Sound
import lean_certs.cert_28_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_74_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 28) (d := 74) (c := cert_28_74) (by decide)
