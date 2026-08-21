import Sound
import lean_certs.cert_12_38

open CertVerify

theorem H12_gt_38 : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 12) (d := 38) (c := cert_12_38) (by native_decide)
