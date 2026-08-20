import Sound
import lean_certs.cert_49_120

open CertVerify

theorem H49_gt_120 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 49) (d := 120) (c := cert_49_120) (by native_decide)
