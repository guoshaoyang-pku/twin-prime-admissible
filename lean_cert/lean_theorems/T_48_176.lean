import Sound
import lean_certs.cert_48_176

open CertVerify

theorem H48_gt_176 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 48) (d := 176) (c := cert_48_176) (by native_decide)
