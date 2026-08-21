import Sound
import lean_certs.cert_41_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_156_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 41) (d := 156) (c := cert_41_156) (by decide)
