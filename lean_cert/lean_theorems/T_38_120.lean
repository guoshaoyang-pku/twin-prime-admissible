import Sound
import lean_certs.cert_38_120

open CertVerify

theorem H38_gt_120 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 38) (d := 120) (c := cert_38_120) (by native_decide)
