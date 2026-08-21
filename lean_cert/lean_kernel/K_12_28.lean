import Sound
import lean_certs.cert_12_28

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_28_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 12) (d := 28) (c := cert_12_28) (by decide)
