import Sound
import lean_certs.cert_38_160

open CertVerify

theorem H38_gt_160 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 38) (d := 160) (c := cert_38_160) (by native_decide)
