import Sound
import lean_certs.cert_28_120

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H28_gt_120_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 28) (d := 120) (c := cert_28_120) (by decide)
