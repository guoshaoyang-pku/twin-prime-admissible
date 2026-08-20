import Sound
import lean_certs.cert_48_116

open CertVerify

theorem H48_gt_116 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 48) (d := 116) (c := cert_48_116) (by native_decide)
