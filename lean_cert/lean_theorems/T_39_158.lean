import Sound
import lean_certs.cert_39_158

open CertVerify

theorem H39_gt_158 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 39) (d := 158) (c := cert_39_158) (by native_decide)
