import Sound
import lean_certs.cert_37_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_156_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 37) (d := 156) (c := cert_37_156) (by decide)
