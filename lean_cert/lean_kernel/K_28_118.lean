import Sound
import lean_certs.cert_28_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_118_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 28) (d := 118) (c := cert_28_118) (by decide)
