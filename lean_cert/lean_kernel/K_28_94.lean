import Sound
import lean_certs.cert_28_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_94_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 28) (d := 94) (c := cert_28_94) (by decide)
