import Sound
import lean_certs.cert_48_150

open CertVerify

theorem H48_gt_150 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 48) (d := 150) (c := cert_48_150) (by native_decide)
