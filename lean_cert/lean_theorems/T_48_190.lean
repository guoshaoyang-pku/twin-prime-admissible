import Sound
import lean_certs.cert_48_190

open CertVerify

theorem H48_gt_190 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 48) (d := 190) (c := cert_48_190) (by native_decide)
