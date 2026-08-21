import Sound
import lean_certs.cert_39_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_156_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 39) (d := 156) (c := cert_39_156) (by decide)
