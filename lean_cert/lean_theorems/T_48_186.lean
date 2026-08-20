import Sound
import lean_certs.cert_48_186

open CertVerify

theorem H48_gt_186 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 48) (d := 186) (c := cert_48_186) (by native_decide)
