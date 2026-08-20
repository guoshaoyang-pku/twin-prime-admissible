import Sound
import lean_certs.cert_48_118

open CertVerify

theorem H48_gt_118 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 48) (d := 118) (c := cert_48_118) (by native_decide)
