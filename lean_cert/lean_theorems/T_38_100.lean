import Sound
import lean_certs.cert_38_100

open CertVerify

theorem H38_gt_100 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 38) (d := 100) (c := cert_38_100) (by native_decide)
