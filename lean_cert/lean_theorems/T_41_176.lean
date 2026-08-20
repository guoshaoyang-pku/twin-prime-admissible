import Sound
import lean_certs.cert_41_176

open CertVerify

theorem H41_gt_176 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 41) (d := 176) (c := cert_41_176) (by native_decide)
