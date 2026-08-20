import Sound
import lean_certs.cert_48_200

open CertVerify

theorem H48_gt_200 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 48) (d := 200) (c := cert_48_200) (by native_decide)
