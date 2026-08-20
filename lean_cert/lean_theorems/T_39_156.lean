import Sound
import lean_certs.cert_39_156

open CertVerify

theorem H39_gt_156 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 39) (d := 156) (c := cert_39_156) (by native_decide)
