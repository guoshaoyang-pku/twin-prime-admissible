import Sound
import lean_certs.cert_15_28

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_28_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 15) (d := 28) (c := cert_15_28) (by decide)
