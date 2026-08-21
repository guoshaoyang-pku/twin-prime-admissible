import Sound
import lean_certs.cert_28_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_56_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 28) (d := 56) (c := cert_28_56) (by decide)
