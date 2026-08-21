import Sound
import lean_certs.cert_11_28

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_28_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 11) (d := 28) (c := cert_11_28) (by decide)
